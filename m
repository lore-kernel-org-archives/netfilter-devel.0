From: "Essien Ita Essien" <essiene@gmail.com>
Subject: RE: compiling libipq example
Date: Thu, 3 Mar 2005 16:26:29 +0100
Message-ID: <WENDYiFmnENgidtlfcb00000001@wendy.ng.splasherstech.com>
References: <42270E69.5020008@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "'Jonas Berlin'" <xkr47@outerspace.dyndns.org>,
	"'Essien Ita Essien'" <essiene@datavibe.net>
In-Reply-To: <42270E69.5020008@outerspace.dyndns.org>
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


>The error is on line 46:

>|                 struct ipq_packet_msg_t *m = ipq_get_packet(buf);

>it should be either

>struct ipq_packet_msg *m

>or

>ipq_packet_msg_t *m

>but not

>struct ipq_packet_msg_t *m

>:)

HOLY CROWBARS!!! 

My bad thnx a million... 

funny thing is EVEN after looking thru the header file... I DIDN'T notice
that typedef error.

Thnx again.
