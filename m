From: Guillaume Morin <guillaume@morinfr.org>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Thu, 6 Jun 2002 21:30:59 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020606193059.GA612@morinfr.org>
References: <Pine.LNX.4.21.0206061947590.19481-100000@dns.toxicfilms.tv> <3CFFAF5D.4010103@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <3CFFAF5D.4010103@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dans un message du 06 jun à 20:52, Emmanuel Fleury écrivait :
> So, what are the INVALID packets ?????

The INVALID state concerns the connection state. INVALID packets carry
connection flags that are not expected by the conntrack.

e.g syn/ack with a previous syn

> After this, I was assuming that we were in the ESTABLISHED state.

They are.

The ACK packets match as NEW are a special case. It happens when
netfilter can't find a related connection. It has been discussed here
plenty of times. It allows to change NAT easily and to interrupt traffic
if for some reason, your firewall crashes or something.

I agree that it should be documented. I really thought it was in the FAQ
or something. Anyway, it has been discussed here several times. Feel
free to submit some documentation updates.

-- 
Guillaume Morin <guillaume@morinfr.org>

    Last night I saw the face of God, but waking I'd forgotten who she was.
                                    (Addict)
