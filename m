From: Guillaume Morin <guillaume@morinfr.org>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 7 Jun 2002 11:43:19 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020607094319.GA595@morinfr.org>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <3D006B9E.1040809@cs.auc.dk> <200206071105.42881.hno@marasystems.com> <3D007D73.9030609@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>
Content-Disposition: inline
In-Reply-To: <3D007D73.9030609@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dans un message du 07 jun à 11:31, Emmanuel Fleury écrivait :
> >iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
> >iptables -A FORWARD -i eth0 -j ACCEPT
> >iptables -A FORWARD -j DROP
> 
> Does that mean that you DROP all the ACKs, even those which are valid
> ?

Of course not, the ACKs packets are matched by --state ESTABLISHED since
they do correspond to an established connection. When ACK packets are
matched as NEW, that means that they do NOT correpond to an established
connection in the conntrack.

-- 
Guillaume Morin <guillaume@morinfr.org>

                  Batailler corps et âmes pour un maudit refus
                              (No one is innocent)
