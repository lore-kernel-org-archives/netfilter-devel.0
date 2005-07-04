From: Roberto Nibali <ratz@tac.ch>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Mon, 04 Jul 2005 12:13:57 +0200
Message-ID: <42C90BE5.7030102@tac.ch>
References: <42C2C053.3040707@tac.ch>
	<20050629154049.GA17717@oknodo.bof.de>	<20050629160923.GF3331@eychenne.org>	<20050703123650.GW3186@sunbeam.de.gnumonks.org>	<20050703220525.GA3331@eychenne.org>	<20050704055541.GA29624@oknodo.bof.de>
	<42C8F151.9080708@tac.ch>	<20050704085913.GX3186@sunbeam.de.gnumonks.org>	<42C900DA.5040906@tac.ch>
	<20050704095351.GZ3186@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>, Herve Eychenne <rv@wallfire.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050704095351.GZ3186@sunbeam.de.gnumonks.org>
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

> Well, to be honest I'm happy that I can say - to a certain extend: I
> don't care abou your particular setup and it's political/organizational
> erstrictions ;)  [don't get me wrong, please].

No, I understand and agree with you. You do the technical correctness of what
you implement and we deal with the correct architectural issues.

> As always, I think we should provide some infrastructure and let people
> use it how they want.  We can try to be flexible, but we cannot optimize
> ever possible setup.

Never asked for that ;).

> Your particular setup would need something like a proxy that does the
> interpretation before it ends up at the centralized logging server.

We also have that (a proxy), but still, it's not that easy ... _but_ also
completely off-topic for this list.

> Alternatively you could store the hostname of the firewall and make the
> interpretation of such a prefix local to that host.  Now you certainly
> can come up with a reason why you can't do that.  And I can frankly
> repeat: well, that's your problem ;)  Technically it is possible...

Yes, let's kill this part of the thread.

Cheers,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
