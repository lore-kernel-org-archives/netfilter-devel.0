From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: testing checksum in helpers is redundant with tcp_window_tracking
Date: Fri, 28 Feb 2003 11:33:15 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0302281127290.27528-100000@blackhole.kfki.hu>
References: <20030227222154.GA9692@pc.ilinx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter@interlinx.bc.ca>
In-Reply-To: <20030227222154.GA9692@pc.ilinx>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 27 Feb 2003 netfilter@interlinx.bc.ca wrote:

> Would it not be a good idea to have some kind of macro defined when
> tcp_window_tracking in built into netfilter so that all of the helpers
> and other code that are doing things like TCP checksum verification
> and whatnot, can avoid wasting cycles doing it a second time?
>
> Then helpers could wrap their tcp checksum calls with something like:
>
> #ifndef TCP_WINDOW_TRACKING
> ...
> #endif

No, I think that is a bad idea. The tcp-window-tracking patch patches the
default helpers (ftp, irc) and remove the redundant checkings. However the
current status of the patch is 'extra'. Not even 'base'. No other
subsystem/patch should be made dependent of it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
