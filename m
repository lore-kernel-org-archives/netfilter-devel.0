From: "Nix N. Nix" <nix@go-nix.ca>
Subject: Re: Minor modification of function dcc_parse in ip_conntrack_irc.c
Date: Tue, 24 Aug 2004 18:43:22 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1093387402.12172.6.camel@dana.go-nix.ca>
References: <1092170081.9955.12.camel@dana.go-nix.ca>
	<411A1F1D.7080804@trash.net> <1092436283.4792.34.camel@dana.go-nix.ca>
	<20040819113532.GO3921@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040819113532.GO3921@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2004-08-19 at 07:35, Harald Welte wrote:
> Which IRC clients did you test this with?  If we put a change in
> ip_conntrack_irc, we should make sure that it suports all major clients
> in both linux and windows world.

I just realized that, since I run an fserve behind the firewall
containing the modified ip_conntrack_irc code (the failure of the fserve
to transmit files prompted me to look into the problem in the first
place), a multitude of IRC clients must have been able to grab files
from my fserve (since I have already completed quite a few uploads). 
All the files I serve contain spaces, and one of them even has a double
quote.

The fserve is fserve.pl an irssi script.
