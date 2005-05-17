From: Patrick McHardy <kaber@trash.net>
Subject: Re: connlimit patch crashes 2.6.11 kernel
Date: Tue, 17 May 2005 22:02:51 +0200
Message-ID: <428A4DEB.8010803@trash.net>
References: <20050510071032Z2651506-22927+755@kps3.test.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mateusz <mateusz@republika.pl>
In-Reply-To: <20050510071032Z2651506-22927+755@kps3.test.onet.pl>
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

Mateusz wrote:
> Problem does not occur when I don't apply connlimit patch to
> kernel.
> 
> [<c0318777>] imq_nf_queue+0xc7/0x1a0

Does the problem occur without the imq patch?

Regards
Patrick
