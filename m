From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: Mirror for Argentina.
Date: Thu, 13 Nov 2003 10:20:05 +0100 (CET)
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0311131012110.18835@dns.toxicfilms.tv>
References: <005a01c3a93c$8e6a9f30$fe01000a@estacion2>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org, webmaster@netfilter.org
Return-path: <netfilter-admin@lists.netfilter.org>
To: Maira Vykus <maira@vykus.com.ar>
In-Reply-To: <005a01c3a93c$8e6a9f30$fe01000a@estacion2>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

> I want to create a mirror for Argentina. I want to know if that is possible.
> Who do i have to email? And what do i have to do?
Sure it is possible :)
Just find a host or two (if you want to seperate ftp and www)
Create a directory for the mirror, and then use rsync to update.
Personally I use cron and this script:

#!/bin/sh
echo "www rsync started" | mail -s "www rsync start" solt@dns.toxicfilms.tv
rsync -avz rsync.netfilter.org::www /var/www/netfilter/www
echo "www rsync stopped" | mail -s "www rsync stopp" solt@dns.toxicfilms.tv

I set up cron to run it every hour. But you can do this daily, not hourly
if you wish.

Having set up your rsync cron job. You can prepare a virtualhost
in apache, or whatever web server you are using, with
www.ar.netfilter.org.

When it's done, just ask Harald (or the webmaster) to add your server IP
to netfilter.org DNS zone.

The similar goes for ftp.
This is the way I made www.pl.netfilter.org and ftp.pl.netfilter.org.


What is the current list of Netfilter Mirrors?

Regards,
Maciej
