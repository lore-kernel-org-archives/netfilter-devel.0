From: Patrick Schaaf <bof@bof.de>
Subject: Re: Feasability of Protocol Filtering
Date: Fri, 25 Apr 2003 10:31:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030425083150.GG6439@oknodo.bof.de>
References: <Pine.LNX.4.44+maildir.0304221620090.1447-100000@woozle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matt Skidmore <fox@woozle.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44+maildir.0304221620090.1447-100000@woozle.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I've got a heretic question:

> Examples:
> Identify and DENY SSH traffic regardless of port

How do you cope with an ftp transfer of a tcpdump capture of some
earlier SSH traffic?

> If it isn't workable that's fine,

It isn't workable for fundamental reasons, but that doesn't mean
it does not make sense to attempt it.

To see the complexities, the parser of tcpdump or ethereal may be
a good place to look at.

best regards
  Patrick
