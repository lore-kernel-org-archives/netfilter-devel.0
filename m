From: Joel Newkirk <firewalldude@newkirk.us>
Subject: Re: A humble proposal
Date: 23 Sep 2003 17:10:08 -0400
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <1064351408.4385.29.camel@alpha.newkirk.us>
References: <7C9884991ADAE0479C14F10C858BCDF5122E46@alderaan.smgtec.com>
Reply-To: firewalldude@newkirk.us
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-admin@lists.netfilter.org>
To: Daniel Chemko <dchemko@smgtec.com>
In-Reply-To: <7C9884991ADAE0479C14F10C858BCDF5122E46@alderaan.smgtec.com>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2003-09-23 at 12:13, Daniel Chemko wrote:
> I have been researching some possible extensions to the Netfilter
> environment, and something has become very necessary for my current
> environment. The following proposal outlines what I wish to implement. I
> am wondering if anyone would find value in this. Plus, I look forward to
> feedback so that I may improve my ideas.


> Suggestion:
> 
> I would like to take pam_iptables and expand it beyond its simple
> structure. Features will include:

My humble suggestion would be that this should be handled in the stateful
connection tracking - If a session is authenticated and certain connections
are to be allowed, then the new allowed connections would be of state 
"related".  Really handy would be the ability to distinguish these particular
'related' connections and feed them through specific chains.  I for one 
would NOT want to simply open the box (or network) wide for every authenticated 
connection, but would like to be able to specify a different set of (more 
permissive) rules for them once authenticated.  Perhaps patch an additional
state - "PAM" or "AUTH".  Or the ability to specify a fwmark that is
automatically implemented for RELATED traffic to the authenticated session,
allowing different chains to be traversed based on the mark found.

j
