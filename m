From: Paul Campbell <paul@donard.lan.campbell-multimedia.co.uk>
Subject: Logging ownership
Date: Thu, 18 Nov 2004 20:16:28 +0000
Message-ID: <20041118201628.GA10213@donard.lan.campbell-multimedia.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi,

Sorry if this is the wrong list for this question, but...

How much work would be involved in sending the packet ownership details, as 
used by ipt_owner.c, from an extension target to an external program or socket?

I've had a look around in the module sources and ... well, I'm a bit lost to 
be honest.  I've not got enough Linux C coding experience to try anything more 
than modifiying ipt_owner.c to add some kprint lines.  Which I dont want, as it 
will generate far too much garbage in the logs etc.

Basically what I am after, and there might be an easier way...  Is to trigger 
a userspace alert when an unknown program attempts to form a new connection.
Personal firewall style for Desktops.

I'm assuming the packet -> program -> user relationship only exists within the
kernel.

-- 

Paul Campbell

Campbell Multimedia
Web Design | PC Sales
+=======================================+
[ WWW:   http://campbell-multimedia.com ]
[ Tel:   07970 510549                   ]
[ Email: info@campbell-multimedia.com   ]
+=======================================+
