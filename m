From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.4] fix ipt_REJECT when used in OUTPUT
Date: Mon, 22 Sep 2003 13:08:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F6ED82E.5060606@trash.net>
References: <20030921144013.GA22223@sunbeam.de.gnumonks.org> <3F6EAFF2.9080303@isfera.ru> <20030922085326.GF31401@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Diadon <diadon@isfera.ru>, David Miller <davem@redhat.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
  linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030922085326.GF31401@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>David, pleas defer applying that patch until further testing is done.
>
>Sorry for the confusion.
>

My bad, I missed that we cannot pass the packet to ip_finish_output2
since it was routed as local input and is missing a neighbour. The correct
fix is to use ip_route_output for packets generated in LOCAL_OUT with
key.saddr set to 0 (the first one I sent to Diadon).

Best regards,
Patrick
