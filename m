From: Stefan Arentz <stefan.arentz@norad.org>
Subject: Re: License of libiptc
Date: Thu, 19 Aug 2004 13:17:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <508E4607-F1D1-11D8-B9D0-000A95678CE8@norad.org>
References: <05FEBCD8-ED29-11D8-9EB5-000A95678CE8@norad.org> <20040819110805.GK3921@sunbeam.de.gnumonks.org>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <20040819110805.GK3921@sunbeam.de.gnumonks.org>
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


On Aug 19, 2004, at 13:08, Harald Welte wrote:

...

> The library is intentional licensed under the GPL and not LGPL.

Ok. I respect that and we will deal with that according to the GPL.

I have two questions though.

Is it ok use system("iptables ...") to talk to iptables from non-GPL 
software?

One thing I just wrote is a module that allows you to control 
ip_conntrack's records. Through a simple /proc interface I can now 
flush records belonging to a certain tuple.

Now this obviously has to be GPLd, which is no problem and we will 
comply to that, but what I was thinking, maybe it is useful to put this 
in a more generic ipconntrackctl command. There have been many requests 
on this and other mailing lists about wanting more control over 
ipconntrack (mostly about manually flushing records), and this could be 
a simple and effective solution.

  S.
