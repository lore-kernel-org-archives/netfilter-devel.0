From: UMEZAWA Takeshi <umezawa@deneb.freemail.ne.jp>
Subject: Re: 'state' match and ICMP time-exceeded
Date: Tue, 19 Nov 2002 23:56:09 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DDA5109122.4A5FUMEZAWA@deneb.freemail.ne.jp>
References: <3DDA49BE0.4A5EUMEZAWA@deneb.freemail.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <3DDA49BE0.4A5EUMEZAWA@deneb.freemail.ne.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


On Tue, 19 Nov 2002 23:25:02 +0900
UMEZAWA Takeshi <umezawa@deneb.freemail.ne.jp> wrote:

> If no NATing rule is given to host0, this problem does not occur.

Sorry, I have misread my memo of test result.

This problem does occur without NATing rule.
The problem is probably not related to NAT.

  +---------------------------------------------------------------+
 / UMEZAWA Takeshi (FAMILY Given) <umezawa@deneb.freemail.ne.jp> /
+---------------------------------------------------------------+
