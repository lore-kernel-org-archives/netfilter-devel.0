From: Herve Eychenne <rv@wallfire.org>
Subject: Re: ip_conntrack cleanup on reconnection?
Date: Sat, 10 Jul 2004 13:57:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040710115729.GA2230@eychenne.org>
References: <opsan10edrkwfgqe@starbug.karlshof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daimonion <daimonion@misanthropos.de>
Content-Disposition: inline
In-Reply-To: <opsan10edrkwfgqe@starbug.karlshof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jul 05, 2004 at 03:20:28PM +0200, Daimonion wrote:

 Hi,

> Having a look at net/ip_MASQUARDE.c the ip_conntrack list should be empty  
> after a device was down (cleanup?), but
> the list still is full of entries.
> Shouldnt the list be empty or, at least rewritten with the new  
> ip-addresses?

Yes, it should. During the last netfilter workshop, after one of my remarks,
Rusty Russell wrote a patch to the MASQUERADE target which cleans the tables
only if the address changes (before, they were cleaned
unconditionnaly).
I don't know when the patch was applied upstream in 2.4 or if it's related
to your problem...

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
