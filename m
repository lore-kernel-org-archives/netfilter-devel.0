From: "Jaume Ribot Caner" <jaumerc@gmx.net>
Subject: Re: Netfilter support for Sharp Zaurus
Date: Fri, 3 Oct 2003 13:31:08 +0200 (MEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <18101.1065180668@www9.gmx.net>
References: <20031002200705.GE5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thaks, you were right!

I have just compiled the kernel again and I have added netfilter support on
it. Then I have flashed the new kernel in the zaurus, I copied the modules
and it works!

Many thanks!

Jaume Ribot

> On Mon, Sep 29, 2003 at 04:51:29PM +0200, Jaume Ribot Caner wrote:
> > Hi all,
> > 
> > I have some trouble trying to add netfilter modules to the PDA Sharp
> Zaur
> us
> > 5500. I have the linux kernel version linux-2.4.6-rmk1-np2-embedix, the
> o
> ne
> > used in the Zaurus. I have compiled the kernel (without errors)
> including
>  the
> > corresponding netfilter support (all as modules). Then, I compiled the
> > modules (make modules) and then installed (make modules_install). 
> 
> The error messages you are reading look like you have a kernel (probably
> still an old one) with no CONFIG_NETFILTER enabled and are then trying
> to load netfilter modules later on.
> 
> 
> -- 
> - Harald Welte <laforge@netfilter.org>            
> http://www.netfilter.org/
> =========================
> =========================
> =========================
> =
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
> 

-- 
NEU FÜR ALLE - GMX MediaCenter - für Fotos, Musik, Dateien...
Fotoalbum, File Sharing, MMS, Multimedia-Gruß, GMX FotoService

Jetzt kostenlos anmelden unter http://www.gmx.net

+++ GMX - die erste Adresse für Mail, Message, More! +++
