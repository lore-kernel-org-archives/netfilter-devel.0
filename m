From: Biswajit Paul <biswajit@cair.res.in>
Subject: Need Help !!!
Date: Wed, 30 Jun 2004 09:56:27 +0530 (IST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.33.0406300953250.18337-100000@aditi.cair.res.in>
References: <20040630043302.24364.46993.Mailman@vishnu.netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <biswajit@cair.res.in>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20040630043302.24364.46993.Mailman@vishnu.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


HI,

   Can u help me ???

 ---------------------------------------------------------------------
 INTRO :
 ----------------------------------------------------------------------
   i need to maintain counters for number of packets

 1. drop
 2. accepted.
 by Netfilter and the protocol distribution among them.

 i put two counters in nf_hook_slow(...) function inB
net/core/netfilter.c

   switch(verdict){
                    case NF_ACCEPT:
                              pkt_accept_count++;
                    case NF_DROP :
                              pkt_drop_count++;
   }

 -----------------------------------------------------------------------
 OBSERVATION :
 -----------------------------------------------------------------------

                when default policy is ACCEPT and i write rules to drop
selective packets i am getting the appropiate values of counters.

                but when the default policy is DROP and no other rule for
ACCEPT then both the counters (pkt_accept_count and pkt_drop_count ) are
incrementing !!!!


 -----------------------------------------------------------------------
 QUERY :
 -----------------------------------------------------------------------

             1. As i am not accepting a single packet the why
pkt_accept_count counter is incrementing !!!

             2. Is there any other better way to do the job ?
 -----------------------------------------------------------------------

 Regards

          Biswajit
