From: Patrick Schaaf <bof@bof.de>
Subject: Re: ip(6)_tables.h: return type difference in ip(6)t_get_target
Date: Fri, 9 Sep 2005 10:49:13 +0200
Message-ID: <20050909084913.GA24509@oknodo.bof.de>
References: <9436.192.35.17.24.1126253758.squirrel@mail.piranho.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henning Peters <hpeters@math.uni-goettingen.de>
Content-Disposition: inline
In-Reply-To: <9436.192.35.17.24.1126253758.squirrel@mail.piranho.net>
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

> Back to my original post: Is there a reason not to change the code as I
> proposed?

Your code change is wrong. See below for proof code. Remember that
a "pointer + integer" always advances the pointer according to the
type of the thing pointed to, i.e. by "integer*sizeof(*pointer)".
And casting seems to have precedence over "+"...

best regards
  Patrick

$ cat foo.c
struct foo { int a; };

int main(int argc, char **argv)
{
        struct foo fooarray[10];
        struct foo *bar = fooarray;
        void *baz = fooarray;

        printf("struct foo *: %p %p\n", bar, bar + 1);
        printf("void *: %p %p\n", baz, baz + 1);
        return 0;
}
$ gcc -o foo foo.c
$ ./foo
struct foo *: 0xbffff878 0xbffff87c
void *: 0xbffff878 0xbffff879
