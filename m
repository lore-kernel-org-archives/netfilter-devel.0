From: Patrick Schaaf <bof@bof.de>
Subject: Re: Hi...
Date: Sat, 18 Jan 2003 20:18:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030118191812.GD12401@oknodo.bof.de>
References: <20030118184245.88397.qmail@web20907.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NetFilter <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel <da_tes@yahoo.com.ar>
Content-Disposition: inline
In-Reply-To: <20030118184245.88397.qmail@web20907.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> www.geocities.com/da_tes/gtk-iptables
> It has the very basics of iptables but in the future will cover much
> more.

Sure. Right now, it shows the current filter table.

It does system("iptables -L >/tmp/tables.tmp"), then reads that file.
HINT: popen() exists for exactly this purpose.

As far as I can see by glancing at the gtk mess, it also opens two
windows with dummy select boxen.

What will gtk-iptables do to help me understand, and sanely manage,
a more than trivial ruleset? What will it be that convinces me to
run a GTK application as root? Assume I'm somewhat familiar with
iptables, and use a combined mangle/nat/filter setup with about
30 things to do right at once. I.e. the usual mess. How could
you help here?

best regards
  Patrick
