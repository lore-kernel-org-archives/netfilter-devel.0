From: Guillaume Morin <guillaume@morinfr.org>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 7 Jun 2002 20:36:00 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020607183600.GD630@morinfr.org>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <3D006B9E.1040809@cs.auc.dk> <200206071105.42881.hno@marasystems.com> <3D007D73.9030609@cs.auc.dk> <20020607094319.GA595@morinfr.org> <3D00839F.6000103@cs.auc.dk> <20020607101713.GB595@morinfr.org> <3D009951.5090004@cs.auc.dk> <20020607133300.GD595@morinfr.org> <3D00CDB4.3060605@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <3D00CDB4.3060605@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Emmanuel,

Dans un message du 07 Jun à 17:13, Emmanuel Fleury écrivait :
> >The documentation is correct because it means
> >the connection in the conntrack sense NOT in the TCP sense.
> 
> I disagree on this point. The documentation is not correct.
> 
> Or, at least, the documentation is not precise enough to figure out
> this particular point (and this can lead the users to have some flaws
> in their firewall).

The documentation is correct because it assumes you understand
"connection" as a conntrack entry. I do agree that it should be 
more explicit.

> The funny thing is that if you have a bad ruleset, you can easily be
> DOSed by some external people which are just sending random ACK packets.
> 
> Those ACKs will create entries in your connection table as ESTABLISHED
> connections with a time-out of.... 5 days !!!!! 8-)

Well no, since the concerned box will reply with a RST.

-- 
Guillaume Morin <guillaume@morinfr.org>

              Why critize what you don't understand ? (Sepultura)
