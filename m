From: "Maciej Soltysiak" <solt@dns.toxicfilms.tv>
Subject: Re: HOPLIMIT
Date: Mon, 16 Feb 2004 14:57:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <004501c3f494$c2150340$0e25fe96@pysiak>
References: <Pine.LNX.4.44.0402161319410.13183-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ok, going back to the issue here.

I called the target "HL" but it was later on renamed in pom-ng to HOPLIMIT.

Running pom-ng and applying HOPLIMIT causes the kernels
which have HL (2.4.21-pre4+ and 2.5.65+) to have these duplicated.

Now, either we rename HOPLIMIT in pom-ng to HL (I opt on this)
or we fix the names/paths in HOPLIMIT pom-ng and submit a patch
to the kernels to rename HL to HOPLIMIT.

I would like to take care of this, but I would like to have a clear
decision. Let's decide whether we stay with HL or switch to HOPLIMIT.
I am in favor of HL.

cvs log says that laforge (ie. Harald) added the patch, so maybe he
should comment on this too.

Regards,
Maciej
