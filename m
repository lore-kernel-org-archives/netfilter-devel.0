From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_conntrack] fix gcc-4.0 compilation
Date: Sat, 11 Jun 2005 17:48:37 +0200
Message-ID: <42AB07D5.3050808@trash.net>
References: <200505241326.00593.michal@rokos.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Michal Rokos <michal@rokos.info>
In-Reply-To: <200505241326.00593.michal@rokos.info>
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

Michal Rokos wrote:
> nf_ct_put() shouldn't be marked as inline since it's not inline.

Applied, thanks.

Regards
Patrick
