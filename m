From: Nils Ohlmeier <lists@ohlmeier.de>
Subject: Re: GnomeMeeting STUN
Date: Fri, 2 Jan 2004 20:46:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401022046.24930.lists@ohlmeier.de>
References: <1072260947.722.25.camel@golgoth01> <1072370922.680.6.camel@golgoth01> <20031226002625.GA8401@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
        Damien Sandras <dsandras@seconix.com>
In-Reply-To: <20031226002625.GA8401@obroa-skai.de.gnumonks.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Friday 26 December 2003 01:26, Harald Welte wrote:
> On Thu, Dec 25, 2003 at 05:48:42PM +0100, Damien Sandras wrote:
> > The problem with the conntrack approach is that we will also have to do
> > the same kind of connection tracker for the SIP protocol :(
>
> IIRC, SIP was the reason for MIDCOM (and FCP, ...).  A conntrack/nat

Yes, that was one of the starting issues for MIDCOM.

> helper for SIP will only work in a very small subset of SIP (no
> hostnames, only IP addresses, no encryption).  Despite that fact,

Ok, there are currently AFAIK no SIP clients available (i'm not sure about the 
commerical ones) which supports SIP encryption. So thats probably a small 
problem.
Problematic is that hostnames or IPs are allowed in all header fields. Not 
many user agents use hostnames in the interesting header fields, especially 
if they are in a private network. But do you want to explain the 'normal' 
users that some phones will work and others not (or even worse some scenarios 
will work with one phone, but some other things will not work with the same 
phone).

> somebody is already working on such a helper.

Ohh, thats interesting. Who is trying to put a full SIP and SDP protocol 
parser into a NAT helper :) (i missed that) ?

Greets
  Nils
