From: Patrick McHardy <kaber@trash.net>
Subject: Re: IPSEC-TUNNEL gives error messages: ip_finish_output: bad unowned
 skb = c5b619e0: PRE_ROUTING LOCAL_IN FORWARD POST_ROUTING
Date: Mon, 22 Sep 2003 19:03:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F6F2B46.2000703@trash.net>
References: <OF73D4154E.C6C4D37F-ONC1256DA9.005340B9@nice.mindspeed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: philippe.vivarelli@mindspeed.com
In-Reply-To: <OF73D4154E.C6C4D37F-ONC1256DA9.005340B9@nice.mindspeed.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Philippe,

philippe.vivarelli@mindspeed.com wrote:

>Does someone has already seen thes messages ?.
>

Please try the latest -bk or apply these two patches, there have been recent
changes which affect these messages:

ChangeSet 1.1283.2.5, 2003/09/11 16:46:44-07:00, laforge@netfilter.org

	[NETFILTER]: Clear nf_debug in ipsec tunnel case.

ChangeSet 1.1315.1.2, 2003/09/12 17:14:53-07:00, acme@conectiva.com.br

	[NETFILTER]: Fix typo in recent ip_input.c changes.

or just disable CONFIG_NETFILTER_DEBUG.


Regards,
Patrick
