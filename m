From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: conntrack performance/DoS formula
Date: Tue, 2 Jul 2002 09:58:03 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207020958.03375@henrik.marasystems.com>
References: <20020628082339.I2890@oknodo.bof.de> <200207011007.25108.hno@marasystems.com> <15648.38427.807689.794217@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: don-nf@isis.cs3-inc.com (Don Cohen)
In-Reply-To: <15648.38427.807689.794217@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 01 July 2002 19.49, Don Cohen wrote:

>  > The ESTABLISHED indicates the TCP state, UNREPLIED indicates the
>  > conntrack state. This is a TCP session that has only seen ACK in
>  > one direction, no packets in the other.
>  >
>  > Almost related note: The connection is not ASSURED.
>
> I'm having trouble making sense of your explanation above.
> This line is supposed to describe a single connection, right?
> Established as a tcp state means the three packet handshake is
> complete?  But that seems to contradict the unreplied.

See the archives. This was discussed to death some days ago.

Summary in short: TCP state only indicates what kind of packets are 
currently seen on the connection. This can be derived from a single 
packet due to "connection pickup".

> Is there any doc for stuff like this?
> - how to read the lines above
> - what exactly these things (unreplied, assured, established ...)
> mean - can I match on ASSURED ?

ASSURED can be matched using the new conntrack match found in 
patch-o-matic. Normally this flag is only used by conntrack to 
garbagecollect invalid entries in case of a DoS attempt. There isn't 
really much use of matching it in rulesets.

Regards
Henrik
