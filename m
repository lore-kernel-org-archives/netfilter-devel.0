From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] locking issue in alter_reply
Date: Thu, 05 Aug 2004 16:29:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <41124446.2090306@trash.net>
References: <411236FA.5080909@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <411236FA.5080909@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

Pablo Neira wrote:

> Hi,
>
> This the first of a set of patches. Actually this patch is a resend, I 
> think that it got lost. Actually, we don't need to write lock the 
> conntrack table because we always call alter_reply with a 
> non-confirmed conntrack.

Harald suggested to concentrate our efforts on nf_conntrack and
only continue to put bugfixes in ip_conntrack, and I agree with him.
This patch is fairly small, but I'll let him decide.

Regards
Patrick
