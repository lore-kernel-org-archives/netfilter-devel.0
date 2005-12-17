From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [RFC][PATCH] ctnetlink port to nf_conntrack take #3
Date: Sat, 17 Dec 2005 18:25:36 +0100
Message-ID: <43A44A10.9040102@eurodev.net>
References: <439419A7.7040100@eurodev.net>	<200512090241.jB92fXDR003303@toshiba.co.jp>	<43A0C749.2050901@trash.net>	<200512150224.jBF2O4Qf011205@toshiba.co.jp>	<43A0D5C2.40000@trash.net>
	<43A15B3E.1080003@eurodev.net> <43A4413A.40200@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43A4413A.40200@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
> 
>> Attached the take #4 of the ctnetlink port to nf_conntrack, it includes
>> lastest Yasuyuki's fixes. But it doesn't fix the issue exposed above.
>> Hope that it will make you save some time.
> 
> 
> Thanks, almost applied :) But I need a Signed-off-by: line for this
> patch.

Sorry, I forgot to add it. The patch with the approapiate header and the
Signed-off-by is available at:

http://people.netfilter.org/pablo/ctnetlink-port.patch

cheers,

-- 
Pablo
