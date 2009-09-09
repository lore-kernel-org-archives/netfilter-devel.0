From: Jay Faulkner <jay.faulkner@mailtrust.com>
Subject: RE: Some clarifications regarding netfilter / iptables
Date: Wed, 9 Sep 2009 12:00:54 -0500
Message-ID: <7407CF92631A85449406062029B4E8461E22CEC3E6@34093-MBX-C14.mex07a.mlsrvr.com>
References: <55120.152.14.80.181.1252512197.squirrel@webmail.ncsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: Balaji Venkatamohan <bvenkat@ncsu.edu>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"netfilter@vger.kernel.org" <netfilter@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <55120.152.14.80.181.1252512197.squirrel@webmail.ncsu.edu>
Content-Language: en-US
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Something that you might find interesting to look at is the NFCT patches -- the author of these patches basically uses an API to add additional conntrack entries to the conntrack table based on an ipvs trigger -- you don't care about the ipvs bit, but the work he did might be interesting to you:

http://www.ssi.bg/~ja/nfct/



Jason Faulkner
Linux Engineer, Rackspace Email & Apps
jason.faulkner@rackspace.com


> -----Original Message-----
> From: netfilter-owner@vger.kernel.org [mailto:netfilter-
> owner@vger.kernel.org] On Behalf Of Balaji Venkatamohan
> Sent: Wednesday, September 09, 2009 12:03 PM
> To: netfilter-devel@vger.kernel.org; netfilter@vger.kernel.org
> Subject: Some clarifications regarding netfilter / iptables
> 
> 
> Hi,
> 
> I am a CSC masters student at NCSU and I am doing a case study on linux
> stateful firewalls for my thesis work. After going through the
> netfilter /
> iptables documentation, I have these following doubts.
> 
> 1. How does the conntrack module code access the header fields of an IP
> packet? Does the accessing of IP packets fall under the functions of
> ip_conntrack module or ip_tables module?
> 
> 2.I want to access the latest version of ip_tables, ip_conntrack and
> ip_conntrack_ftp source code. I need to write a simple module on the
> lines
> of ip_conntrack to allow a simple connection of my choosing. So I need
> to
> know where to start coding. I will be grateful if I get some help in
> this
> regard.
> 
> 3. Is it possible to write our own ip_conntrack module and if yes can
> we
> define our own state table? Who defines a state table and where is it
> defined?
> 
> 
> Thanks and Regards,
> 
> Balaji
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
