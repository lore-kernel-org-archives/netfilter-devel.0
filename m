From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] locking issue in alter_reply
Date: Fri, 06 Aug 2004 00:23:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4112B351.6070806@eurodev.net>
References: <411236FA.5080909@eurodev.net> <41124446.2090306@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41124446.2090306@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

Patrick McHardy wrote:

> Harald suggested to concentrate our efforts on nf_conntrack and
> only continue to put bugfixes in ip_conntrack, and I agree with him.
> This patch is fairly small, but I'll let him decide.


I see, actually I haven't seen that patch. Well I agree with you, that 
layer 3 abstraction for the conntrack looks interesting. So I'll 
concentrate my efforts in nf_conntrack since now.

regards,
Pablo
