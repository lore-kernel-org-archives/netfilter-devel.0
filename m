From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: Extending LOG target to display pid
Date: Thu, 07 Jul 2005 06:32:19 +0000
Message-ID: <42CCCC73.50902@outerspace.dyndns.org>
References: <42CB1E31.1000802@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nick Hay <nickjhay@hotmail.com>
In-Reply-To: <42CB1E31.1000802@hotmail.com>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting Nick Hay on 2005-07-05 23:56 UTC:
> My original intention was to replicate some part of Windows' ZoneAlarm
> package: the ability to recognise which program was asking for access,
> and to filter based on that.  Noticing a strange packet that was blocked
> by my filter on outgoing ports, and not being able to find out where it
> came from was the immediate motivation :)

I made this kind of program some years ago ; it pops up a window if some
yet-unknown program tries to access anything.. You then have the options
to create a rule on-the-fly if you want or just accept/reject that
specific packet. It uses the QUEUE target of iptables which sends the
whole packet to userspace. I have tweaked the kernel code to send the
PID as well. This whole thing has only been tested with outgoing
connections, and it worked well.

It isn't user-friendly like ZoneAlarm, but it sure is hacker-friendly :)

I have three clients implemented, one text-based (for desperate console
hacking), one gtk-based written in C and one java-gnome-based (gtk
wrapper lib for java) written in Java. The Java one has the most
features. It would probably not be too hard to rewrite the java version
for some other toolkit like Swing or SWT.

Here's some screenshots, the first one from the java-gnome version and
the second from the C-gtk version:

  http://xkr47.outerspace.dyndns.org/tmp/firefly-java-1.png
  http://xkr47.outerspace.dyndns.org/tmp/firewall-layout-5.png

If you are interested I could pack it up for you..

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCzMxxxyF48ZTvn+4RAo/VAJ9Rxw8mc483cOMz/zvvWlGikz7ycACeIuWN
/yLfUiUvzg7pcKJHwDeb/gY=
=UALz
-----END PGP SIGNATURE-----
