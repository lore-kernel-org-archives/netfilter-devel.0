From: Mark Atwood <mra@pobox.com>
Subject: Re: Syncookie firewall
Date: 06 Jun 2002 15:03:45 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <m34rgg9i9q.fsf@khem.blackfedora.com>
References: <20020606192927.6B7684DCE@lists.samba.org>
	<15615.53673.287531.24270@isis.cs3-inc.com>
	<200206062334.17294.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: <200206062334.17294.hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom <hno@marasystems.com> writes:
> 
> To ensure interoperability you must also filter out any options on future 
> packets of that TCP not known to be 100% compatible with your SYN+ACK.

Widespread deployment of this advice will condemn every future TCP
improvement to the hell that ECN is in today.

-- 
Mark Atwood   | Well done is better than well said.
mra@pobox.com | 
http://www.pobox.com/~mra
