From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack performance/DoS formula
Date: Mon, 1 Jul 2002 10:49:15 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15648.38427.807689.794217@isis.cs3-inc.com>
References: <20020628082339.I2890@oknodo.bof.de>
	<20020630103131.X4136@oknodo.bof.de>
	<15647.24217.324807.354846@isis.cs3-inc.com>
	<200207011007.25108.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <200207011007.25108.hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom writes:
 > Don Cohen wrote:
 > 
 > > On a related subject, I'm worried that UNREPLIED might not mean
 > > what I think it does.  Your data contains things like:
 > >  tcp 6 387070 ESTABLISHED src=9.163.211.64 dst=165.130.71.38 sport=3228
 > >  dport=1301 [UNREPLIED] src=165.130.71.38 dst=9.163.211.64 sport=1301
 > >  dport=3228 use=1
 > > How can one half of the connection be established while the other half
 > > is unreplied?
 > 
 > The ESTABLISHED indicates the TCP state, UNREPLIED indicates the conntrack 
 > state. This is a TCP session that has only seen ACK in one direction, no 
 > packets in the other.
 > 
 > Almost related note: The connection is not ASSURED.

I'm having trouble making sense of your explanation above.
This line is supposed to describe a single connection, right?
Established as a tcp state means the three packet handshake is
complete?  But that seems to contradict the unreplied.

Is there any doc for stuff like this?
- how to read the lines above
- what exactly these things (unreplied, assured, established ...) mean
- can I match on ASSURED ?
