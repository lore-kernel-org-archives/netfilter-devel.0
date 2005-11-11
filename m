From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] ip_conntrack_proto_tcp
Date: Fri, 11 Nov 2005 14:02:03 +0100
Message-ID: <4374964B.3070409@eurodev.net>
References: <1131637730.14044.12.camel@quant> <437495E7.5050500@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, Vlad Drukker <vlad@storewiz.com>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <437495E7.5050500@eurodev.net>
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
> Vlad Drukker wrote:
> 
>>Attached patch for ip_conntrack to account TCP sessions started with SYN
>>+PUSH flags. Looks weird, but some HW vendors do TCP their own way. 
>>
>>Let's earn some points from RFC 1025.
> 
> 
> I see this patch like a sort of workaround to make broken devices with

Sorry, I meant: ... to get working broken devices with ...

-- 
Pablo
