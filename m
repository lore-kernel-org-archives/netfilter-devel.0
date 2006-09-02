From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Named realm - updated
Date: Sat, 02 Sep 2006 14:09:22 +0200
Message-ID: <44F97472.2070901@trash.net>
References: <200606042135.49361.simonl@parknet.dk> <4496C7B8.5020006@trash.net>
	<200609020127.40248.simon@parknet.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Lodal <simon@parknet.dk>
In-Reply-To: <200609020127.40248.simon@parknet.dk>
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

Simon Lodal wrote:
> Ok, here is a new version.

Applied, thanks Simon. I have a patch to add support for named
fwmarks for iptables and iproute, so I'm probably going to move
parts of this to some central place.

>>>Index: linux-2.6/include/linux/netfilter/xt_realm.h
>>>===================================================================
>>>--- linux-2.6/include/linux/netfilter/xt_realm.h	(revision 44)
>>>+++ linux-2.6/include/linux/netfilter/xt_realm.h	(revision 45)
>>>@@ -5,6 +5,7 @@
>>> 	u_int32_t id;
>>> 	u_int32_t mask;
>>> 	u_int8_t invert;
>>>+	u_int8_t is_named_realm;
>>

> The compatibility policy is good at preventing a lot of good ideas from 
> becoming anything but that.

Well, this idea just wasn't good :)
