From: Rolf Fokkens <fokkensr@fokkensr.vertis.nl>
Subject: Re: PATCH: extra conntrack stats
Date: Sun, 27 Apr 2003 17:23:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200304271523.h3RFNZk05880@fokkensr.vertis.nl>
References: <200304192142.h3JLg1S03466@fokkensr.vertis.nl> <20030427124835.GA990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030427124835.GA990@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sunday 27 April 2003 02:48 pm, Harald Welte wrote:
> This is inacceptable, the only way to implement this is via per-cpu
> counters that are added at the time you read them out (like the iptables
> per-cpu local counters)

Oh boy! It's even worse! Even without this patch we have a concurrency 
problem: the timout! It's updated frequently I guess, and it's also protected 
by the same lock: ip_conntrack_lock!

Well, after all this panic and calming down something constructive:

Should a lock per contrack entry be considered? This increases the 
concurrency for different connections anyhow.
