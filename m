From: "Richard" <richard@o-matrix.org>
Subject: RE: target for modifying conntrack timeout value
Date: Tue, 30 Nov 2004 20:53:15 -1000
Message-ID: <EINSTEINAStRc0JFaTi000063f4@einstein.systemmetrics.com>
References: <200412010920.49048.immidi@spymac.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Kiran Kumar Immidi'" <immidi@spymac.com>,
	<netfilter-devel@lists.netfilter.org>
In-reply-to: <200412010920.49048.immidi@spymac.com>
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

This would change the timeout value for all udp conntrack. I'd like to have
more granular control, e.g. after match of certain ports or other
conditions.

Thanks,
Richard


> -----Original Message-----
> From: Kiran Kumar Immidi [mailto:immidi@spymac.com]
> Sent: Tuesday, November 30, 2004 5:51 PM
> To: Richard; netfilter-devel@lists.netfilter.org
> Subject: Re: target for modifying conntrack timeout value
> 
> On Wednesday 01 December 2004 06:16, Richard wrote:
> 
> > I wonder if there is a target to modify the conntrack timeout value. For
> 
>   Its not a target, you just need to set it using sysctl;
> 
> sysctl -w net.ipv4.netfilter.ip_conntrack_udp_timeout_stream=<timeout>
> --
> Regards,
> Kiran Kumar Immidi
