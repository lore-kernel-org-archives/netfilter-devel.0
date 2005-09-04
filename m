From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] kill __ip_ct_expect_unlink_destroy
Date: Sun, 04 Sep 2005 19:51:22 +0200
Message-ID: <431B341A.6030305@trash.net>
References: <430E2E0B.1010109@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <430E2E0B.1010109@eurodev.net>
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

Pablo Neira wrote:
> The following patch kills __ip_ct_expect_unlink_destroy and export 
> unlink_expect as ip_ct_unlink_expect. As it was discussed [1], the 
> function __ip_ct_expect_unlink_destroy is a bit confusing so better do 
> the following sequence: ip_ct_destroy_expect and ip_conntrack_expect_put.
> 
> [1]https://lists.netfilter.org/pipermail/netfilter-devel/2005-August/020794.html 

Also applied, thanks Pablo.
