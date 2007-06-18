From: Simon <simon.xhz@gmail.com>
Subject: Re: Follow packets in rules
Date: Mon, 18 Jun 2007 11:12:12 -0500
Message-ID: <f7de5e030706180912x1233c6e8rfbdfb2459cb8b7de@mail.gmail.com>
References: <f7de5e030706121441h6b817d82td49e3eb4346e5a12@mail.gmail.com>
	<002101c7ad8c$cb6d67c0$1706380a@adidf.efs.sante.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Fabrice Rafart" <fabrice.rafart@efs.sante.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <002101c7ad8c$cb6d67c0$1706380a@adidf.efs.sante.fr>
Content-Disposition: inline
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

> I know this possibility and I use it for log some packets but I can't double
> all my rules (almost 200) by a log rule.

Hi Fabrice,
  I don't log everything too.  I usually choose some types of
information to log, and some IP's to log from.  For example, a friend
connected to my pc and logged in to a secure website, at that moment,
i stop logging this guy, the website logs in its own way.  Somebody
that is still trying stuff and has not yet connected for X minutes
will then get flagged as a suspect and different logging takes place
(to avoid DoS, and others).

  One last detail, is if your rules are done well, you don't need to
log much.  Logging more would be for "debuging" or "development" in my
opinion.  So when I was suggesting to have a log identify each rules
passed by each packets it wasn't for a production environment.  But
then again, if you asked this kind of question, i hope it wasn't for a
prod system!

  As for testing the rules, I think the best way is to craft packets
and send them to the interface.  There are some hacking tools that
permit to make raw ethernet frames and provide "easy" way of modifying
packets at the ip or tcp level and they work like scripts that you
execute.

Good luck!
  Simon
