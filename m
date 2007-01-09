From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Conntrack helper for SANE
Date: Tue, 09 Jan 2007 12:12:25 +0100
Message-ID: <45A37899.1030600@trash.net>
References: <459BD14B.7050508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Michal Schmidt <mschmidt@redhat.com>
In-Reply-To: <459BD14B.7050508@redhat.com>
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

Michal Schmidt wrote:
> Hello Patrick,
> 
> This is nf_conntrack_sane, a netfilter connection tracking helper module
> for the SANE protocol used by the 'saned' daemon to make scanners
> available via network.
> The SANE protocol uses separate control & data connections, similar to
> passive FTP. The helper module is needed to recognize the data
> connection as RELATED to the control one.
> 
> I believe all the issues you pointed out in the previous version are
> fixed now.

Yes, this looks good. I've queued it for 2.6.21 with some minor cleanup
(fix overly long line, fix whitespace in two casts), thanks.
