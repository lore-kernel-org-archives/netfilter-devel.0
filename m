From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_recent: add module parameter for changing GID of
 /proc/net/ipt_recent/*
Date: Sat, 08 Jul 2006 12:42:36 +0200
Message-ID: <44AF8C1C.8070800@trash.net>
References: <44AF0E7E.70507@iastate.edu> <44AF205F.3070600@trash.net>
	<44AF259F.6000204@iastate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Daniel De Graaf <danield@iastate.edu>
In-Reply-To: <44AF259F.6000204@iastate.edu>
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

Daniel De Graaf wrote:
> Patrick McHardy wrote:
> 
>>>Daniel De Graaf wrote:
>>>
>>>>This patch adds an ip_list_gid module parameter to ipt_recent,
>>>>which is meant to be used in combination with the ip_list_perms.
>>>>In the current implementation, the files must either be
>>>>world-writable or require programs which write to them to be (at
>>>>least) setgid root.
>>>>
> Here's an updated patch against 2.6.18-rc1.


I'm fine doing this, but just allowing to set group ownership without
user ownership will probably soon make someone else send me a second
patch, so please take care of this as well. Please also make sure your
patch applies with -p1 in the kernel tree root and don't forget to
sign off.
