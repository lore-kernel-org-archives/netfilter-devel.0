From: Patrick Schaaf <bof@bof.de>
Subject: Re: Multiple Targets
Date: Sat, 19 Feb 2005 09:28:51 +0100
Message-ID: <20050219082851.GA18228@oknodo.bof.de>
References: <7174b1e405021900052b4545c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Ben La Monica <ben.lamonica@gmail.com>
Content-Disposition: inline
In-Reply-To: <7174b1e405021900052b4545c4@mail.gmail.com>
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

> I'm writing a firewall application for ISPs, and I'm realizing that my
> tables could potentially get very long because there is no way to
> perform multiple targets on a matched rule.

There is: it is called user-defined chains.

Of course, seeing your example, you would need one such user-defined
chain for each different MARK value you want to set. Oh, and RETURN
would need to return two levels, as you seem to allude to near the
end of your posting. (BTW, I think THAT would be a generally
useful extension, -j RETURN --up NR)

That approach is impractical. "user-defined chains" is an easy answer,
but not a complete solution, as your examples clearly illustrate.

Unfortunately your proposals also appear to be very ambitiuous.

> I had the idea of allowing multiple targets, as long as the targets
> before the last were non-terminating. Following on my example above,
> it would look something like this:
> 
> iptables -N auth
> iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:00 -j
> MARK,RETURN --set-mark 1
> iptables -A auth -i int+ -m mac --mac-source 00:00:00:00:00:01 -j
> MARK,RETURN --set-mark 2
> ... n ...
> iptables -A auth -i int+ -m mac --mac-source FF:FF:FF:FF:FF:FF -j
> MARK,RETURN --set-mark n
> 
> This way, you could chain several targets together, and it would
> execute them all until it hit a target that would decide the fate of
> the packet. You could mark, log, and accept a packet with a single
> match if you wanted to.

Problem: target options. How would the commandline parser see that
--set-mark belongs to MARK, and --log-prefix belongs to LOG? What
about the hypothetical case of several targets having target options
with identical names?

Apart from that, the approach will certainly break binary compatibility
with the former iptables, and thus WILL NOT BE DONE in the iptables
framework, because binary compatibility is considered GOD.

Harald, what does pkttables bring to the table in this regard?

Generally, I think the reasoning behind wanting such a feature, is sound.

best regards
  Patrick
