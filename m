From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: Re: [PATCH 2.4/2.5]
Date: 29 Jun 2003 22:20:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056918054.1068.96.camel@exile>
References: <1056913883.1068.70.camel@exile>  <1056915465.9614.59.camel@pc>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Brian J. Murrell" <netfilter@interlinx.bc.ca>
In-Reply-To: <1056915465.9614.59.camel@pc>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2003-06-29 at 21:37, Brian J. Murrell wrote:
> 
> I am having a hard time thinking of a scenario where a client would want
> to listen on a port other than it's default and/or listen on multiple
> ports for commands from the backup server.
> 
Well not a lot of common scenarios, I will give you that, but
I just figured that in some situations, people run services 
on different ports, not the standard ports the services are normally
associated with. Sometimes because those ports are blocked by
another firewall, sometimes to confuse portscanners. I just
figured that the other conntrackers in the kernel had this
feature so I added it to your code...

Regards,
Filip
