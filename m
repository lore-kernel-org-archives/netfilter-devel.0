From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Syncookie firewall
Date: Thu, 6 Jun 2002 23:34:17 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206062334.17294.hno@marasystems.com>
References: <20020606192927.6B7684DCE@lists.samba.org> <15615.53673.287531.24270@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: don-nf@isis.cs3-inc.com (Don Cohen),
	netfilter-devel@lists.samba.org
In-Reply-To: <15615.53673.287531.24270@isis.cs3-inc.com>
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

>  > Because there is no good way to know the servers TCP options before
>  > you have opened the TCP connection to the server, and you do not
>  > want to open the TCP connection to the server before the client has
>  > acknowledged the connection...
>
> Fortunately, all of these options are ... optional, so the firewall
> can, if it doesn't know better, simply not use them.

To ensure interoperability you must also filter out any options on future 
packets of that TCP not known to be 100% compatible with your SYN+ACK.

> The timestamp option is not a problem in this case.  The firewall only
> responds to a few packets and for those it can supply its own
> timestamp (or not).  After it establishes both halves of the
> connection it just forwards the packets and the timestamps (seems to
> me) should work out fine.

The timestamp option must be real all the time, or never. You cannot suddently 
switch TCP timestamp source in the middle of a TCP connection. Doing so will 
serverely break PAWS.

Note: The TCP timestamp option is not the same as the IP timestamp option. TCP 
timestamps has nothing to do with time, only the progress of relative time 
within a TCP.

Regards
Henrik
