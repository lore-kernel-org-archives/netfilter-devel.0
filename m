From: "Henning Peters" <hpeters@math.uni-goettingen.de>
Subject: Re: ip(6)_tables.h: return type difference in ip(6)t_get_target
Date: Fri, 9 Sep 2005 12:02:38 +0200 (CEST)
Message-ID: <8277.192.35.17.24.1126260158.squirrel@mail.piranho.net>
References: <9436.192.35.17.24.1126253758.squirrel@mail.piranho.net><20050909084913.GA24509@oknodo.bof.de>
	<20050909090358.GB24509@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org, Patrick Schaaf <bof@bof.de>,
	Henning Peters <hpeters@math.uni-goettingen.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20050909090358.GB24509@oknodo.bof.de>
To: "Patrick Schaaf" <bof@bof.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,
yes, you are right. Thank you for the pointer and example code.

return (struct ip6t_entry_target *) ((void *)e + e->target_offset);

seems ugly, but necessary if compilers are more strict to match the return
type. I would appreciate if this could be applied in order to faciliate
C++/iptables development. I am not sure whether other C compilers might
not see this issue aswell?!

Henning


Patrick Schaaf sagte Fr, 9.09.2005, 11:03:
>>> Back to my original post: Is there a reason not to change the code as I
>>> proposed?
>>
>> Your code change is wrong. See below for proof code. Remember that
>> a "pointer + integer" always advances the pointer according to the
>> type of the thing pointed to, i.e. by "integer*sizeof(*pointer)".
>> And casting seems to have precedence over "+"...
>
> Damn, my proof code was nonsensical in that it not tested for the
> "casting seems to" property. Corrected code below. So, casting
> has higher precedence than "+". Which does not make your proposed
> change more correct, it's just wrong in a different way :)
>
> best regards
>   Patrick
>
> $ cat foo.c
> struct foo { int a; };
> struct bar { int a; int b; };
>
> int main(int argc, char **argv)
> {
>         struct foo fooarray[10];
>         struct foo *bar = fooarray;
>
>         printf("struct foo *: %p %p\n", bar, bar + 1);
>         printf("struct bar *: %p %p\n", bar, (struct bar *) bar + 1);
>         printf("void *: %p %p\n", bar, (void *) bar + 1);
>         return 0;
> }
> $ gcc -o foo foo.c
> $ ./foo
> struct foo *: 0xbffff878 0xbffff87c
> struct bar *: 0xbffff878 0xbffff880
> void *: 0xbffff878 0xbffff879
>
>
