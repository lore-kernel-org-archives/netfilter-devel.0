From: Peter Surda <shurdeek@routehat.org>
Subject: Re: ipset -L causing kernel panic when using macipmap
Date: Mon, 06 Dec 2004 11:04:15 +0100
Message-ID: <41B42E9F.2090208@routehat.org>
References: <41B07CD8.8080800@routehat.org>
	<Pine.LNX.4.58.0412061024150.5880@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.58.0412061024150.5880@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:

>'ipset -v' always reports the version number.
>  
>
Yes it was 1.0.

>Please use ipset 2.0 (i.e ipset utility and the kernel part from
>patch-o-matic-ng) from the svn repository or download the snapshots from
>http://people.netfilter.org/kadlec/ipset/install.html.
>
>It was a useful report because the bug was still present in 2.0 and
>was fixed now.
>  
>
A whole upgrade is quite complicated, because I have my own distribution 
with a lot of patches in kernel and iptables and I wouldn't have the 
time to test it after an upgrade at the moment. In the meantime I'll try 
to backport this fix and also -S and -R functionality instead :-).

Do I see correctly that the bug was a "- -" instead of "-" in the 
list_members function or is it more complicated and I have to use the 
whole diff of p-o-m-ng between 1.12. and 6.12.?

>Best regards,
>Jozsef
>  
>
Thnx,

Peter
