From: "Balaji Venkatamohan" <bvenkat@ncsu.edu>
Subject: Some clarifications regarding netfilter / iptables
Date: Wed, 9 Sep 2009 12:03:17 -0400 (EDT)
Message-ID: <55120.152.14.80.181.1252512197.squirrel@webmail.ncsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Hi,

I am a CSC masters student at NCSU and I am doing a case study on linux
stateful firewalls for my thesis work. After going through the netfilter /
iptables documentation, I have these following doubts.

1. How does the conntrack module code access the header fields of an IP
packet? Does the accessing of IP packets fall under the functions of
ip_conntrack module or ip_tables module?

2.I want to access the latest version of ip_tables, ip_conntrack and
ip_conntrack_ftp source code. I need to write a simple module on the lines
of ip_conntrack to allow a simple connection of my choosing. So I need to
know where to start coding. I will be grateful if I get some help in this
regard.

3. Is it possible to write our own ip_conntrack module and if yes can we
define our own state table? Who defines a state table and where is it
defined?


Thanks and Regards,

Balaji
