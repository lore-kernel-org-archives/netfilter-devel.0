From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/11] Rename struct nf_conntrack_protocol
Date: Fri, 03 Nov 2006 13:39:22 +0100
Message-ID: <454B387A.8070801@trash.net>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210913.910411244@wlug.westbo.se>
	<454B3112.1060200@trash.net>
	<Pine.LNX.4.64.0611031309470.15562@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.64.0611031309470.15562@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:
> On Fri, 3 Nov 2006, Patrick McHardy wrote:
> 
> 
>>Something related I wanted to do for a long time is get rid of the
>>confusing nf_ct_foo vs. nf_conntrack_foo naming.
> 
> 
> Yeees! (Including the 'nf_conn' variation as well.)

Yes, that one should go as well :)
