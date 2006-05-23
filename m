From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Netfilter: SNMP NAT helper: fix memleak
	snmp_object_decode
Date: Tue, 23 May 2006 11:31:32 +0200
Message-ID: <4472D674.4000403@trash.net>
References: <20060522224039.GW23243@moss.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20060522224039.GW23243@moss.sous-sol.org>
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

Chris Wright wrote:
> If kmalloc fails, error path leaks data allocated from asn1_oid_decode().

Thanks Chris, applied. "len" can't exceed the real packets length, so
I don't think this can really be triggered remotely. Feel free to add
to -stable though.
