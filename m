From: Kiran Kumar Immidi <immidi@spymac.com>
Subject: Re: target for modifying conntrack timeout value
Date: Wed, 1 Dec 2004 09:20:49 +0530
Message-ID: <200412010920.49048.immidi@spymac.com>
References: <EINSTEINorwBpP6m6PU0000637c@einstein.systemmetrics.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Richard" <richard@o-matrix.org>,
 <netfilter-devel@lists.netfilter.org>
In-Reply-To: <EINSTEINorwBpP6m6PU0000637c@einstein.systemmetrics.com>
Content-Disposition: inline
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

On Wednesday 01 December 2004 06:16, Richard wrote:

> I wonder if there is a target to modify the conntrack timeout value. For

  Its not a target, you just need to set it using sysctl;

sysctl -w net.ipv4.netfilter.ip_conntrack_udp_timeout_stream=<timeout>
-- 
Regards,
Kiran Kumar Immidi
