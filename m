From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: Syncookie firewall
Date: Thu, 6 Jun 2002 09:28:41 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15615.36281.187120.257236@isis.cs3-inc.com>
References: <20020606020322.05BF64258@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: <20020606020322.05BF64258@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 > From: Henrik Nordstrom <hno@marasystems.com>
 > In my opinion, If you do "syncookie" in a firewall then the TCP should be 
 > terminated there, with another TCP in to the real server. I.e. a proxy 
 > solution.
Why do you think that's better than simply forwarding packets with
sequence/ack# translation?  Surely it's less efficient.  And it raises
questions about how much data to buffer between the two and how that
can be controlled.
