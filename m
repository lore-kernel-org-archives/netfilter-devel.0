From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: MAC/IP pair match submission
Date: Wed, 21 Apr 2004 17:42:08 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404211726250.726-100000@chris.camcom.co.uk>
References: <Pine.LNX.4.44.0404081333110.29813-100000@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0404081333110.29813-100000@chris.camcom.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

I would like to announce a new version of the "macmatch" patch, v0.0.5. 
This increases the size of the /proc write buffer, to fix some problems 
with long interface names, and includes a fix for an error message that 
was logged at too low a priority.

The download locations have also changed. You can find all the 
documentation (that exists so far) at:

  [http://www.firerack.com/devel/iptables_macmatch]

and download the source code itself at:

  [http://www.firerack.com/downloads/iptables_macmatch]

I still haven't heard from anyone regarding integration into POM. Can 
anyone tell me if there is a procedure for this, or someone who I should 
be pestering, or if there's a reason why this isn't appropriate for POM?

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
