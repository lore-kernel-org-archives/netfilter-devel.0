From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: conntrack performance/DoS formula
Date: Tue, 2 Jul 2002 18:53:27 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207021853.27973.hno@marasystems.com>
References: <15643.31140.525551.843205@isis.cs3-inc.com> <20020702183242.E7684@oknodo.bof.de> <20020702183547.F7684@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020702183547.F7684@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf wrote:
> > Everybody, have a look at http://bei.bof.de/ex1/. There's a bunch of
> > pictures, which may become legible together with reading my recent
> > mails on this thread.
>
> Ah - maybe I should at least note that the x-axis is bucket length,
> on a log-2 scale, The y-axis is the number of occurences, log-10.

Any explanation for the odd tails with very long bucket chains in the original 
hash?

In many cases the rest of the graph looks quite smooth not making one expect 
such tail, so I wonder if these may be an artefect of tomething else (bug, or 
incorrect input data).

Regards
Henrik
