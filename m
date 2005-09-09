From: "Henning Peters" <hpeters@math.uni-goettingen.de>
Subject: Re: ip(6)_tables.h: return type difference in ip(6)t_get_target
Date: Fri, 9 Sep 2005 10:15:58 +0200 (CEST)
Message-ID: <9436.192.35.17.24.1126253758.squirrel@mail.piranho.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi Pablo,

as I said in my previous mail I am linking to libiptables and not to
libiptc. I was seeing libiptables API as a more higher level interface and
therefore I was choosing this. I think we agree in this point.

Still, both API/libs seem to be undocumented, but at least they are
advertised on netfilter.org: "multiple layers of API's for 3rd party
extensions".

> b) iptables is entirely written in C, linking libiptc to C++ code isn't
a good a idea.

Recently I have used a C++ wrapper for the OpenGL library which is also
written entirely in C. This gave me a quite robust impression although it
is intermixed code. The same goes for several other OOP wrappers which I
don't have experience in, but have heard about it. Technically, the C code
is not translated by the C++ compiler (like some other guys tried on this
list), the C++ compiler just knows the calling conventions of compiled C
code, is this a bad idea?

My impression is that if it is a regular API/library (as it is the case in
libiptables), then I don't see arguments not to use it in C++ software if
the alternatives are resource consuming and error prone. I see the
intermix features of C++ as a feature, why don't use it?

Maybe I am not aware of certain dangers in doing so. If you think this is
the case, please give me more details on this issue.

Back to my original post: Is there a reason not to change the code as I
proposed? I think this is a syntax error anyway so we don't have to waste
time on a C vs. C++ discussion.

Thanks,
Henning


Pablo Neira sagte Fr, 9.09.2005, 00:54:
> Henning Peters wrote:
>> This software is being written in c++. I want to avoid using the
command-line to talk to iptables for efficiency. Including iptables
headers and linking to libiptables seemed reasonable for me. But
compiling
>> with g++ (gcc version 3.3.4 (pre 3.3.5 20040809)) and linking to the
c-libs (extern "C" stuff) gave me a compile error:
>
> Two comments:
>
> a) The internal library used by iptables (libiptc) is undocumented and
its use is discouraged.
> b) iptables is entirely written in C, linking libiptc to C++ code isn't
a good a idea.
>
> So, you should call iptables via system(). It isn't great but you'll
have less problems.
>
> --
> Pablo
