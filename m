From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: dst cache overflow
Date: Wed, 10 Jan 2007 16:01:17 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0701101556310.28241@ask.diku.dk>
References: <60665.10.1.1.10.1167776653.squirrel@www.arcoscom.com>   
	<55635.10.1.1.10.1167946368.squirrel@www.arcoscom.com>
	<45A492AE.2030909@trash.net>
	<54528.195.55.244.106.1168435239.squirrel@www.arcoscom.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-511516320-824992256-1168441277=:28241"
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: ArcosCom Linux User <linux@arcoscom.com>
In-Reply-To: <54528.195.55.244.106.1168435239.squirrel@www.arcoscom.com>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-824992256-1168441277=:28241
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable



On Wed, 10 Jan 2007, ArcosCom Linux User wrote:

> El Mie, 10 de Enero de 2007, 8:15, Patrick McHardy escribi=F3:
>> ArcosCom Linux User wrote:
>>> The log says:
>>> Dec 30 00:52:27 cura kernel: dst cache overflow

The log message "dst cache overflow" is normally related to overflow of=20
the route cache.  The max_size of the route cache can be adjusted through=
=20
/proc/sys/net/ipv4/route/max_size.

What is your settings in /proc/sys/net/ipv4/route/?

Run command:
  grep . /proc/sys/net/ipv4/route/*

Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
---511516320-824992256-1168441277=:28241
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
LARTC mailing list
LARTC@mailman.ds9a.nl
http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc

---511516320-824992256-1168441277=:28241--
