From: Patrick <patrick@xsinet.co.za>
Subject: Header Matching
Date: Tue, 24 Jun 2003 11:11:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624091119.GC2532@flaptop.xsinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



hi

what matching would i use to match the following : 

Jun 12 17:01:40 grovyle IN=br0 OUT=br0 PHYSIN=eth1 PHYSOUT=eth0 SRC=24.50.199.67 DST=196.36.190.95 LEN=1500 TOS=0x00 PREC=0x40 TTL=106 ID=28216 DF PROTO=TCP SPT=21531 DPT=4662 WINDOW=50000 RES=0x00 ACK PSH URGP=0 

i would like to match the PREC= value ? 

any ideas ? 

P 


-- 
Rhode's Law:
	When any principle, law, tenet, probability, happening, circumstance,
	or result can in no way be directly, indirectly, empirically, or
	circuitously proven, derived, implied, inferred, induced, deducted,
	estimated, or scientifically guessed, it will always for the purpose
	of convenience, expediency, political advantage, material gain, or
	personal comfort, or any combination of the above, or none of the
	above, be unilaterally and unequivocally assumed, proclaimed, and
	adhered to as absolute truth to be undeniably, universally, immutably,
	and infinitely so, until such time as it becomes advantageous to
	assume otherwise, maybe.
