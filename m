From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 1/2] flow match for 2.6.11
Date: Tue, 12 Jul 2005 17:36:47 +0100
Message-ID: <db0rj4$q4h$1@sea.gmane.org>
References: <20050628234912.GB23662@wsc.edu> <42D3B9C7.1070507@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42D3B9C7.1070507@ufomechanic.net>
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

I'm backporting this to 2.6.11 as I see the conntrack-event-api in
pom-ng SVN for 2.6.11 is the same as for 2.6.12 apart from ftp sequence
number adjusting takes a 32bit parameter in 2.6.12, and your patches
apply cleanly.

I'm just tracking down why function ipct_flow_inc gets called with quite
different events parameter under 2.6.11 for a connection than under 2.6.12

It gets called 4 times for a new connection, 2.6.11
(EVENTS is hex)

FLOW INC ipct_flow_inc 341 EVENTS=471[ new=1, related=2]
FLOW INC ipct_flow_inc 341 EVENTS=78[ new=1, related=2]
FLOW INC ipct_flow_inc 341 EVENTS=401[ new=1, related=2]
FLOW INC ipct_flow_inc 341 EVENTS=18[ new=1, related=2]

compared with 2.6.12
FLOW INC ipct_flow_inc 341 EVENTS=471[ new=1, related=2]
FLOW INC ipct_flow_inc 341 EVENTS=411[ new=1, related=2]



Anyway, I mention it in case you have any hints.

Amin
