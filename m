From: sverre <sverre@gmx.net>
Subject: Re: bug in 2.4.18 netfilter ?
Date: Fri, 5 Jul 2002 13:58:01 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020705115800.GA192@gmx.net>
References: <20020705000210.GA2038@gmx.net>
Reply-To: sverre@gmx.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020705000210.GA2038@gmx.net>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

gonna try to reply to myself before anyone else does ;)
the "bug" was indeed in the firewall script (surprise!) - the nat table
was not flushed between the two ppp connestions. During the second
connection all the outgoing packets had the source IP address I was 
assigned in the previous ppp connection, so no wonder I didnt get any
response.
Sorry for questioning the netfilter bugfreeness and wasting your
bandwidth with needless mails ;)
best regards,

-- 


			sverre	<sverreQgmx.net>
