From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: conntrack performance/DoS formula
Date: Mon, 1 Jul 2002 10:07:25 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207011007.25108.hno@marasystems.com>
References: <20020628082339.I2890@oknodo.bof.de> <20020630103131.X4136@oknodo.bof.de> <15647.24217.324807.354846@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: don-nf@isis.cs3-inc.com (Don Cohen), Patrick Schaaf <bof@bof.de>
In-Reply-To: <15647.24217.324807.354846@isis.cs3-inc.com>
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

> On a related subject, I'm worried that UNREPLIED might not mean
> what I think it does.  Your data contains things like:
>  tcp 6 387070 ESTABLISHED src=9.163.211.64 dst=165.130.71.38 sport=3228
>  dport=1301 [UNREPLIED] src=165.130.71.38 dst=9.163.211.64 sport=1301
>  dport=3228 use=1
> How can one half of the connection be established while the other half
> is unreplied?

The ESTABLISHED indicates the TCP state, UNREPLIED indicates the conntrack 
state. This is a TCP session that has only seen ACK in one direction, no 
packets in the other.

Almost related note: The connection is not ASSURED.

Regards
Henrik
