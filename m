From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Syncookie firewall
Date: Thu, 6 Jun 2002 19:32:04 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206061932.04510.hno@marasystems.com>
References: <20020606020322.05BF64258@lists.samba.org> <15615.36281.187120.257236@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: don-nf@isis.cs3-inc.com (Don Cohen),
	netfilter-devel@lists.samba.org
In-Reply-To: <15615.36281.187120.257236@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Don Cohen wrote:

> Why do you think that's better than simply forwarding packets with
> sequence/ack# translation?  Surely it's less efficient.  And it raises
> questions about how much data to buffer between the two and how that
> can be controlled.

Because there is no good way to know the servers TCP options before you have 
opened the TCP connection to the server, and you do not want to open the TCP 
connection to the server before the client has acknowledged the connection...

Adjusting the sequence numbers is the simple part of the picture. Does not 
worry me.. this is what the NAT engine is doing.

What worries me is

  * Window scaling
  * Timestamp
  * ECN

and a number of other end-to-end TCP options that depend on correct 
negotiation during SYN.

Sure, window scaling and ECN can be set by configuration if you know your 
server, but there is no good way to deal with the timestamp option short of 
forcibly filter it out entirely from the TCP stream.

Regards
Henrik
