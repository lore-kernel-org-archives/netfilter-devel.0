From: Thomas Poehnitzsch <thomas.poehnitzsch@informatik.tu-chemnitz.de>
Subject: Re: Hi, new version is out...
Date: Thu, 30 Jan 2003 01:24:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030130002452.GI27561@calix.csn.tu-chemnitz.de>
References: <20030129020254.48207.qmail@web20909.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter developer mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20030129020254.48207.qmail@web20909.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Daniel,

On Tue, Jan 28, 2003 at 11:02:54PM -0300, Daniel E. Testa wrote:

> Hi everybody... I'm sorry for the delay of gtk-iptables v1.3.2. It adds
> as new feature the selection of interfaces, some visual improvements
> and more   cleaned code. 

it is nice to see a developer trying to ease the use of netfilter for
mere mortals. You are probably doing quite a good job with your program
(haven't tested it yet), _but_ in my humble opinion this is the wrong
place for your announcements.

This list is for discussions of netfilter itself. Have a look at the
other postings. They are all related to netfilter itself, like adding
new matches, fixing bugs and improving its speed.

I would much rather see your announcements on sourceforge, freshmeat or
maybe even on the netfilter user mailinglist.

In case my opinion conflicts with the opinion of other subscribers feel
free to correct or criticise me.

> I'd like to know what you think about it, about the code and what
> improvements I should add first starting from here.

Well, as I said before, I haven't tested it yet. But some month ago I
had to test several other GUIs for netfilter and there were some things
I really missed in all of them:

- a check for duplicate (useless) rules
    this may sound stupid, but I have seen rulesets with duplicate
    rules, and this should be quite easy to filter out

- a packet tester
    Just like when creating a rule, a user should be prompted for test
    criteria (like portranges, interfaces, ...). Given those values the
    GUI could find rules (possibly) matching those criteria and
    highlight them. Later on it could create a tree-like structure
    showing all possible outcomes based on the decision in each possibly
    matching rule.
    In my opinion this would be of great value when debugging/extending
    lengthy rulesets.

If you do not understand any of my suggestions, just drop me an e-mail.

Ciao!
    Thomas

-- 
What did you do to the cat? It looks half-dead.
                         --Schroedinger's wife
