From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [FUN] New target: passive OS fingerprinting.
Date: Thu, 27 Nov 2003 17:33:10 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031127173310.56eeb5f8.johnpol@2ka.mipt.ru>
References: <20031124101806.GI4888@obroa-skai.de.gnumonks.org>
	<20031124230108.752aab76.johnpol@2ka.mipt.ru>
	<20031126194454.GC3740@obroa-skai.de.gnumonks.org>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__27_Nov_2003_17_33_10_+0300_F59hg/6EHD2TIw29"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031126194454.GC3740@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Thu__27_Nov_2003_17_33_10_+0300_F59hg/6EHD2TIw29
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Nov 2003 20:44:54 +0100
Harald Welte <laforge@netfilter.org> wrote:

> 
> Ok, I'll apply it to CVS.

Thank you.

Here is third patchset on top of previous two.
It adds:

Some "smart" hardware/software changes MSS while doing NAT/DSL, so
make additional compare with "good" MSS value(predefined 1460).
----------------------------
Whitespace cleanup.
----------------------------
Packets from outside(loopback is outside too) may have equal to
fingerprint ttl, not necessarily lesser.

If we have timestamp option, do not compare it with one from
fingerprint.(For now it is always 0).

Please test and apply.

> -- 
> - Harald Welte <laforge@netfilter.org>            
> http://www.netfilter.org/

	Evgeniy Polyakov ( s0mbre )

--Multipart=_Thu__27_Nov_2003_17_33_10_+0300_F59hg/6EHD2TIw29--
